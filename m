Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030659Ab2HWRaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:30:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49875 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab2HWRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:30:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, chaosman@ontika.net, muthur@gmail.com,
        kerolasa@iki.fi, linux-kernel@vger.kernel.org
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
Date: Thu, 23 Aug 2012 10:29:45 -0700
In-Reply-To: <1345333117-2826-1-git-send-email-mail@danrl.de> (Dan Luedtke's
	message of "Sun, 19 Aug 2012 01:38:37 +0200")
Message-ID: <877gspms8m.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/HeQ6qNiH4OZuFU/keX2ejBlN6gfszTN0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0166]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dan Luedtke <mail@danrl.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Luedtke <mail@danrl.de> writes:

> +/**
> + * struct lanyfs_opts - mount options
> + * @uid:			userid of all files and directories
> + * @gid:			grouid of all files and direcotries
> + * @dmask:			directory mask
> + * @fmask:			file mask
> + * @discard:			issue discard requests on block freeing
> + * @flush:			force instant writing of changed data
> + */
> +struct lanyfs_opts {
> +	uid_t			uid;
> +	gid_t			gid;
A small nit.  Those above two lines should be:
	kuid_t			uid;
	kgid_t			gid;
> +	unsigned int		dmask;
> +	unsigned int		fmask;
> +	unsigned int		discard:1,
> +				flush:1;
> +};

Eric
