Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0EYKZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:25:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56556 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab0EYKZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:25:44 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <20100525095110.GG22515@bicker>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 25 May 2010 03:25:37 -0700
In-Reply-To: <20100525095110.GG22515@bicker> (Dan Carpenter's message of "Tue\, 25 May 2010 11\:51\:10 +0200")
Message-ID: <m1d3wk2s7y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: error27@gmail.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dan Carpenter <error27@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch] kobject: free memory if netlink_kernel_create() fails
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> There is a kfree(ue_sk) missing on the error path if 
> netlink_kernel_create() fails.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

Oops.

> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index 59c1551..08e15f7 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -378,6 +378,7 @@ static int uevent_net_init(struct net *net)
>  	if (!ue_sk->sk) {
>  		printk(KERN_ERR
>  		       "kobject_uevent: unable to create netlink socket!\n");
> +		kfree(ue_sk);
>  		return -ENODEV;
>  	}
>  	mutex_lock(&uevent_sock_mutex);
