Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1DNRHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:07:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63335 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1DNRHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xp39Hfd2X6fUhe0fn0M6CFe/q+MRfn9uyRY65K3hjSOemqCk5HwUgk45m36ggt0Nr/
         TfjXnX0Hid/AJNo6/8SqucA0MVV2Qkh8uJwbFkLm5voBx+2wV67/5e960bpd0mc4FU/o
         dnpXnI4ZjDK5U9UZnIti1/p7tJshK+agKb9sc=
MIME-Version: 1.0
In-Reply-To: <1302800120-31560-1-git-send-email-segoon@openwall.com>
References: <1302800120-31560-1-git-send-email-segoon@openwall.com>
Date: Thu, 14 Apr 2011 21:07:36 +0400
Message-ID: <BANLkTimNgb+5W4kjKiarRAU=EH=X=_vUzQ@mail.gmail.com>
Subject: Re: [PATCH] char: agp: fix OOM and buffer overflow
From: Vasiliy Kulikov <segooon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -       if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
> +       cur_memory = atomic_read(&bridge->current_memory_agp);
> +       if ((cur_memory + page_count > bridge->max_memory_agp) ||
> +           (cur_memory + page_count < page_count))
I should have said that current_memory_agp is already protected by
agp_fe.agp_mutex, so the patch doesn't break atomic operation
(otherwise there is also a race between the check and use of
current_memory_agp).
