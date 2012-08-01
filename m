Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2HAPkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:40:06 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:52572 "EHLO
	homiemail-a43.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752729Ab2HAPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:40:04 -0400
X-Greylist: delayed 49223 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 11:40:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=aIpt6BoKuKQ0mgDkub/EgTr2tVH6l7L3Pac2kMCjRuy9qLr49hYcBSA5GRRyu
	vLmXwa4rC6SgkOpIezXEuJIYMelWXrFFfyefMKYpMjz+evaP9ugpgLgzzGqy68rU
	ZOs2tTtXocz9byDJlBR0If5h8+7aamUw5tn7T3eQQpZba8=
Message-ID: <50194DD1.9030806@shealevy.com>
Date: Wed, 01 Aug 2012 11:40:01 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
CC: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Build failure when installing atm ambassador firmware
References: <50188D89.3040404@shealevy.com> <20120801072247.589c7162@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20120801072247.589c7162@thirdoffive.cmf.nrl.navy.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chas,

On 08/01/2012 07:22 AM, chas williams - CONTRACTOR wrote:
> On Tue, 31 Jul 2012 21:59:37 -0400
> Shea Levy<shea@shealevy.com>  wrote:
>
>> Hello,
>>
>> When building with
>> MODLIB=/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/modules/3.5.0
>> and
>> ="/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware",
>> building Linux 3.5 with CONFIG_ATM_AMBASSADOR=m fails with:
>>
>> "make[2]: *** No rule to make target
>> `"/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware"/./',
>> needed by
>> `"/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware"/atmsar11.fw'.
>> Stop."
>
> i think it might be trying to tell you that the target directory
> $INSTALL_FW_PATH doesn't exist and is a prerequisite to actually
> perform the action.
>

Indeed, creating the directory first fixes the issue. Is this expected 
behaviour, or a bug in the build system?

 >
> it complains about atmsar11.fw first because it just happens to be the
> first firmware that needs to be installed.
>
> /scratch/chas/net-next relax.53% ls -ld /tmp/funk
> ls: cannot access /tmp/funk: No such file or directory
> /scratch/chas/net-next relax.54% make INSTALL_FW_PATH="/tmp/funk" firmware_install
> make[1]: *** No rule to make target `/tmp/funk/./', needed by `/tmp/funk/atmsar11.fw'.  Stop.
> make: *** [firmware_install] Error 2
> /scratch/chas/net-next relax.55% mkdir /tmp/funk
> /scratch/chas/net-next relax.56% make INSTALL_FW_PATH="/tmp/funk" firmware_install
>    INSTALL /tmp/funk/atmsar11.fw
>    MKDIR   /tmp/funk/e100/
>    INSTALL /tmp/funk/e100/d101m_ucode.bin
>    INSTALL /tmp/funk/e100/d101s_ucode.bin
>    INSTALL /tmp/funk/e100/d102e_ucode.bin
> ...
>
> i am somewhat concerned that it appears to have an extra set of "'s in
> the path as well.  how are you passing in INSTALL_FW_PATH?  i can get
> the same result with:
>
> /scratch/chas/net-next relax.57% make 'INSTALL_FW_PATH="/tmp/funk"' firmware_install
> make[1]: *** No rule to make target `"/tmp/funk"/./', needed by `"/tmp/funk"/atmsar11.fw'.  Stop.
> make: *** [firmware_install] Error 2
>
> but it would be wrong to do it this way.

Yeah, I had an extra bit of quotation that I've now removed. Thanks!

Cheers,
Shea Levy
