Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1CTDxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 23:53:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1CTDxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 23:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=axA0bUZNcqb8Q4L4kRevcvwjEIVkxqiJS1pU5FV8RUIRjaJ9i6Bxuc0MX27xdSvusw
         5MlItBt1ilpQma8CStVg==
MIME-Version: 1.0
In-Reply-To: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com>
References: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com>
Date: Sat, 19 Mar 2011 20:52:56 -0700
Message-ID: <AANLkTi=BySqSLSMCNqbWO7eyZhQZ5=W35L4Ndqo6Q5tS@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: fix futex sanitization definition/prototype mismatch
From: Michel Lespinasse <walken@google.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 8:45 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> Commit 8d7718aa082aaf30a0b4989e1f04858952f941bc changed "int"
> to "u32" in the prototypes but not the definition.
> I missed this when I saw the patch go by on LKML.
>
> We cast "u32 *" to "int *" since we are tying into the underlying
> atomics framework, and atomic_t uses int as its value type.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Reviewed-by: Michel Lespinasse <walken@google.com>

Looks fine. I had held off from changing types within
futex_atomic_op_inuser() because the signed-ness of oparg and cmparg
was important there, but I agree changing at least the user pointer
types in futex_* operations is nice and safe.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
