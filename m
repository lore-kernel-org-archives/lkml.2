Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0LUSqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:46:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39350 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0LUSqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dYYwPSiX/22l5ABmdC2Cb+iMulvTUawbKUd6MllClzW9phBfFFeFanGyenLQZQ3SPO
         KOmiprpAr++dAQMVZe1t2ED6BTJcUkG3Lm22cYjRCfkMZ7nAtIk6nguhRf2yy+62KW00
         HeVRP6+Sn7QmxK6KyUDRP/DDtRkWRPsjPChPo=
MIME-Version: 1.0
In-Reply-To: <20101221181800.GA8166@albatros>
References: <20101221181800.GA8166@albatros>
Date: Tue, 21 Dec 2010 13:46:41 -0500
X-Google-Sender-Auth: 1iYBiGJaS0lvItC8XZtd5qWTILc
Message-ID: <AANLkTikS6rs-AFGmtTfuRdELJ5+y=o4g1i0Xk9KDFRiv@mail.gmail.com>
Subject: Re: [RFC] ipv4: add ICMP socket kind
From: Colin Walters <walters@verbum.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>,
        Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 1:18 PM, Vasiliy Kulikov <segooon@gmail.com> wrote:
> Hi,
>
> This patch adds IPPROTO_ICMP socket kind.  It makes it possible to send
> ICMP_ECHO messages and receive corresponding ICMP_ECHOREPLY messages
> without any special privileges.  In other words, the patch makes it
> possible to implement setuid-less /bin/ping.
>
> A new ping socket is created with
>
>    socket(PF_INET, SOCK_DGRAM, IPPROTO_ICMP)

And the default is to allow any uid to do this (modulo LSM)?

If you really have a burning desire to get rid of setuid /bin/ping,
why not just do it in userspace via message passing to/from a
privileged process, and avoid a lot of code in the kernel?  It's much
more flexible.  You could, for example, limit it to once a second by
default, allow only one process doing this per uid, etc.
