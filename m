Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab0KRO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:26:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0KRO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:26:26 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=wIm5vl0-W6IA:10 a=kj9zAlcOel0A:10 a=ClVPYAY4FByjUdLuiT8neg==:17 a=20KFwNOVAAAA:8 a=-IdwL6Zk-7xmrvJ8G9sA:9 a=HkPGVt0CGjcxss1ZrB4sqyxe_wIA:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 wl=env:18 a=ClVPYAY4FByjUdLuiT8neg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 66.68.83.102
Date: Thu, 18 Nov 2010 08:26:24 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        torvalds@linux-foundation.org, joe@perches.com,
        drosenberg@vsecurity.com, mingo@elte.hu, eugeneteo@kernel.org,
        kees.cook@canonical.com, akpm@linux-foundation.org, jmorris@namei.org,
        morgan@kernel.org, casey@schaufler-ca.com
Subject: Re: [PATCH] capabilities/syslog: open code cap_syslog logic to fix
 build failure
Message-ID: <20101118142624.GA927@hallyn.com>
References: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> @@ -274,7 +274,20 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	char c;
>  	int error = 0;
>  
> -	error = security_syslog(type, from_file);
> +	/*
> +	 * If this is from /proc/kmsg we only do the capabilities checks
> +	 * at open time.
> +	 */
> +	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> +		if (dmesg_restrict && !capable(CAP_SYS_ADMIN))

Any chance we could introduce a new capability for this?

thanks,
-serge
