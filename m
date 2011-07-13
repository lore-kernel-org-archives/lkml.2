Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab1GMJVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:21:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108Ab1GMJV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:21:29 -0400
Message-ID: <4E1D6396.1070200@suse.cz>
Date: Wed, 13 Jul 2011 11:21:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not write to builddir in modules_install
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>	<1310470780-12330-1-git-send-email-mmarek@suse.cz> <CAM_iQpWfSFPcvDJCDwS9ADCEvw-6A3wyUh+kkhgqHOi2Zx_eSg@mail.gmail.com>
In-Reply-To: <CAM_iQpWfSFPcvDJCDwS9ADCEvw-6A3wyUh+kkhgqHOi2Zx_eSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.7.2011 03:05, Américo Wang wrote:
> On Tue, Jul 12, 2011 at 7:39 PM, Michal Marek<mmarek@suse.cz>  wrote:
>> Let depmod.sh create a temporary directory in /tmp instead of writing to
>> the build directory as root. The mktemp utility should be available on
>> any recent system (and there is already scripts/gen_initramfs_list.sh
>> relying on it).
>>
>
> Hmm, why not use $objtree/.tmp_depmod?

That's how it was done before and it's broken. make modules_install is 
usually ran as root and there is no guarantee that root has write access 
to the build directory (it can be on nfs).

Michal
