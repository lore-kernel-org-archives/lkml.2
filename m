Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0LQP4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:56:53 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47746 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0LQP4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J5NqhRXVxHaZ1SDusdBdfdVtHdvZbBjftS/dAx/MT/dMaJlsDa3ZhUe6iDhq31HYRL
         5+ORfmvlccvwTzPW5pDIBUh2XZAa38x9pHvtCA3R0rnZaHc5bbWuzyaQXqTnVMoRvAAU
         rUqTgl14/kIFJRUHD0NfkndHcirJRnGZb3SwM=
MIME-Version: 1.0
In-Reply-To: <20101217152458.GA11162@mail.hallyn.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
Date: Fri, 17 Dec 2010 17:56:51 +0200
Message-ID: <AANLkTinPBAPjeEdhn21JN6zVpAKDHR9=3gszj84CyyNx@mail.gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as creator/owner
 of uts_namespace
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 5:24 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> +/*
> + * userns count is 1 for root user, 1 for init_uts_ns,
> + * and 1 for... ?
> + */
>  struct user_namespace init_user_ns = {
>        .kref = {
> -               .refcount       = ATOMIC_INIT(2),
> +               .refcount       = ATOMIC_INIT(3),

+1 is for init_nsproxy ;-)
