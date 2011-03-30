Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1C3J4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:56:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61603 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1C3J4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Pf5pk96mHN1h9p2dPlnrS0x5ZdlGZcIihw8HWD9F8/aMnbysiBt70ehFmjZTb+8StR
         uXU+aOsLqfOX99RWoqn75V5ZXu1N7aR5z9kxFLYMgc2Df1Tvvgjx6M4wMzOMsgRJrt0f
         yFRy1Bdprb2U5PGOYNmPuXXmJJuTWTIL5OTLQ=
MIME-Version: 1.0
In-Reply-To: <1301465343-6861-1-git-send-email-vapier@gentoo.org>
References: <1301465343-6861-1-git-send-email-vapier@gentoo.org>
Date: Wed, 30 Mar 2011 12:56:18 +0300
Message-ID: <AANLkTim8S_hjGj3m7FF+1gKOk0Rp1g350NdA1L8kiqzg@mail.gmail.com>
Subject: Re: [PATCH] proc: constify status array
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 9:09 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> -static const char *task_state_array[] = {
> +static const char * const task_state_array[] = {

Why this is needed for task_state_array, but not for, say, tgid_base_stuff?

00000000000000e0 d task_state_array
0000000000000a50 r tgid_base_stuff

This double const is ugly.
