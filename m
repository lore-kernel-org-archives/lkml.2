Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1EFKPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:15:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:55511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1EFKPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:15:23 -0400
Message-ID: <4DC3CA39.30806@suse.cz>
Date: Fri, 06 May 2011 12:15:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add $KERNELRELEASE to firmware install path
References: <20110505173939.GA20575@dev1756.snc6.facebook.com>
In-Reply-To: <20110505173939.GA20575@dev1756.snc6.facebook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding David Woodhouse and lkml to CC, in general it's usually better 
to CC topic lists in addition to lkml, rather than instead of lkml.)

On 5.5.2011 19:39, Arun Sharma wrote:
> Useful in the presence of multiple kernels with different
> firmware versions.

The changelog should also include the udev version that is able to find 
the firmware there (v127, August 2008). FWIW, SUSE has been using this 
patch since about that time, but we forgot to push this :-|. Anyway

Acked-by: Michal Marek <mmarek@suse.cz>


> Signed-off-by: Arun Sharma<asharma@fb.com>
>
> diff --git a/Makefile b/Makefile
> index e712243..cb715df 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -997,7 +997,7 @@ depend dep:
>
>   # ---------------------------------------------------------------------------
>   # Firmware install
> -INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
> +INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
>   export INSTALL_FW_PATH
>
>   PHONY += firmware_install
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

