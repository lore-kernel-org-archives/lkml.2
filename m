Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1FIRTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:19:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64528 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1FIRTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KURG2yyqHTr8atjJJXYGmppAPikjcX7ziN2Y1hibNJ9GVrOMt6agynpmgzEsP/Yqs+
         b/oG/BOKii1JOBirgUahkUj+f87Uu6dmd/34XvRRQTKXG800JkBi2i5gV/opWEqX0mWY
         ln0ZbWvvN4/JtaXdnoJzFM2YrbxwK7Xcrlzy4=
MIME-Version: 1.0
In-Reply-To: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
References: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
Date: Thu, 9 Jun 2011 20:19:50 +0300
Message-ID: <BANLkTikAvnam2WNTBMj_J5yBHrxJxSjLuw@mail.gmail.com>
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler-update.patch added to
 -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
        ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 11:45 PM,  <akpm@linux-foundation.org> wrote:
> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update
> +++ a/kernel/sysctl.c
> @@ -2515,6 +2515,7 @@ int proc_dointvec_unsigned(struct ctl_ta
>  {
>        struct do_proc_dointvec_minmax_conv_param param = {
>                .min = &zero,
> +               .max = (int *) table->extra2,
>        };
>        return do_proc_dointvec(table, write, buffer, lenp, ppos,
>                                do_proc_dointvec_minmax_conv, &param);

This is still buggybecause "zero" is only 1 variable and max can be an array.
Sysctl boundary comparisons are done element-by-element.
