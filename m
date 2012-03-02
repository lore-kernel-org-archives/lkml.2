Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449Ab2CBJGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:06:07 -0500
Received: from mx0.aculab.com ([213.249.233.131]:50735 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756956Ab2CBJGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:06:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Resend [PATCH] netfilter: Fix copy_to_user too small size parametre.
Date: Fri, 2 Mar 2012 09:05:10 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E87@saturn3.aculab.com>
In-Reply-To: <1330621743-12883-1-git-send-email-santoshprasadnayak@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Resend [PATCH] netfilter: Fix copy_to_user too small size parametre.
Thread-Index: Acz3zuDC8PiMqBgKS+OkWAnLlQEKTgAhBdhQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "santosh nayak" <santoshprasadnayak@gmail.com>,
        <bart.de.schuymer@pandora.be>
Cc: <pablo@netfilter.org>, <kaber@trash.net>, <shemminger@vyatta.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 02 Mar 2012 09:05:11.0181 (UTC) FILETIME=[92905BD0:01CCF853]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> -	if (copy_to_user(hlp, m->u.match->name, 
> EBT_FUNCTION_MAXNAMELEN))
> +	char name[EBT_FUNCTION_MAXNAMELEN] = {};
> +
> +	strncpy(name, m->u.match->name, sizeof(name));
> +	if (copy_to_user(hlp, name, EBT_FUNCTION_MAXNAMELEN))
>  		return -EFAULT;

strncpy() is very rarely the function you are looking for.
In this case it MIGHT be right (since you do a fixed size
copy_to_user).
OTOH there is no need to also initialise name[].
And it isn't entirely clear whether the application
is allowed to be given a non-terminated string.

	David


