Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab1C3VD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:03:28 -0400
Received: from mx2.netapp.com ([216.240.18.37]:33805 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab1C3VD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:03:28 -0400
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="536476882"
Message-ID: <4D939A8F.5000509@netapp.com>
Date: Wed, 30 Mar 2011 17:03:11 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Lightning/1.0b2 Lanikai/3.1.9
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: linux-kernel@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares (bisected)
References: <20110330203823.GA3228@dtor-ws.eng.vmware.com>
In-Reply-To: <20110330203823.GA3228@dtor-ws.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for letting me know.  What does your exports file look like, and which mounts do and don't work?

Bryan

On 03/30/2011 04:38 PM, Dmitry Torokhov wrote:
> Hi,
> 
> The following commit appears to the open preventng me from mounting some
> of my NFS shares (not all, of them, just some):
> 
> 8f70e95f9f4159184f557a1db60c909d7c1bd2e3 is the first bad commit
> commit 8f70e95f9f4159184f557a1db60c909d7c1bd2e3
> Author: Bryan Schumaker <bjschuma@netapp.com>
> Date:   Thu Mar 24 17:12:31 2011 +0000
> 
>     NFS: Determine initial mount security
>     
>     When sec=<something> is not presented as a mount option,
>     we should attempt to determine what security flavor the
>     server is using.
>     
>     Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Here is the bisect log:
> 
> [dtor@dtor-ws linus]$ git bisect log
> git bisect start
> # good: [4bbba111d94781d34081c37856bbc5eb33f6c72a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
> git bisect good 4bbba111d94781d34081c37856bbc5eb33f6c72a
> # bad: [0ce790e7d736cedc563e1fb4e998babf5a4dbc3d] Linux 2.6.39-rc1
> git bisect bad 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d
> # good: [e285c1746accb80620e511f9c72e9893beeedc0e] Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
> git bisect good e285c1746accb80620e511f9c72e9893beeedc0e
> # bad: [8d49a77568d1105ff3e64aec484dac059f54824e] Merge branch 'for-2.6.39/drivers' of git://git.kernel.dk/linux-2.6-block
> git bisect bad 8d49a77568d1105ff3e64aec484dac059f54824e
> # bad: [5aafdea448fb86412a6f8e46df518c1545d32436] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> git bisect bad 5aafdea448fb86412a6f8e46df518c1545d32436
> # bad: [9458ea567a72ebd3852c2d764d32c0f2fb61d0df] MIPS: IP22/IP28: Convert to new irq_chip functions
> git bisect bad 9458ea567a72ebd3852c2d764d32c0f2fb61d0df
> # good: [ae005cbed12d0b340b04b59d6f5c56e710b3895d] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> git bisect good ae005cbed12d0b340b04b59d6f5c56e710b3895d
> # bad: [1685f3b158a244d4f6e205e67c84483fffcb2d9f] MIPS: SMTC: Move declaration of smtc_init_secondary to <asm/smtc.h>.
> git bisect bad 1685f3b158a244d4f6e205e67c84483fffcb2d9f
> # good: [988b6dceb0ae6d642587c8594529b94f6be0c5ea] NFSv4.1: remove GETATTR from ds commits
> git bisect good 988b6dceb0ae6d642587c8594529b94f6be0c5ea
> # good: [35124a0994fc02545b14b9fa3aad000b3331f1c0] Cleanup XDR parsing for LAYOUTGET, GETDEVICEINFO
> git bisect good 35124a0994fc02545b14b9fa3aad000b3331f1c0
> # bad: [8f70e95f9f4159184f557a1db60c909d7c1bd2e3] NFS: Determine initial mount security
> git bisect bad 8f70e95f9f4159184f557a1db60c909d7c1bd2e3
> # good: [7c5130588d691a3b34d02312f1bd1b6d56fe0100] NFS: lookup supports s alternate client
> git bisect good 7c5130588d691a3b34d02312f1bd1b6d56fe0100
> # good: [7ebb931598cd95cccea10d4bc4c0123a464ea565] NFS: use secinfo when crossing mountpoints
> git bisect good 7ebb931598cd95cccea10d4bc4c0123a464ea565
> 

