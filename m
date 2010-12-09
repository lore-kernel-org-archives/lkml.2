Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0LIIjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:39:49 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:59224 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0LIIjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zt3WgRbPfWKSP37pO32X995CemW09X5TaHtRTxOEjkU2AnZXpDG6BuYvuywlZ0RX5P
         kDju8iTSK2SsBGuvoQNKrnpmjpNx67Di+EtjEnsJqUM0JjXEoGBVZ0VyrK0FZIGqpiH0
         OnFzcQ+5yfXei80qf76hVNnXltJjYTn3JjNA4=
MIME-Version: 1.0
In-Reply-To: <1291881376-4729-1-git-send-email-ike.pan@canonical.com>
References: <1291881376-4729-1-git-send-email-ike.pan@canonical.com>
Date: Thu, 9 Dec 2010 09:39:46 +0100
Message-ID: <AANLkTimUpXe34tSzvOJ_oo=fyqdAhwkk6xnN10BbdWrH@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] ideapad: hotkey enablement
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 8:56 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> Here are the enablement patches for hotkey events on ideapads and these patches
> are made against current checkout of mainline kernel.
>
> After last time posting on LKML, there are several feedback and these patches
> are modified.
>
> From Dmitry Torokhov, using markup on functions to let the compiler knows where
> to put and passing private variable instead of using global vairable. The

Great,

> acpi_handle is still a global variable becuase we need to pass handle pointer
> to rfk_set with its opcode but only one data argument available.

Of course there is only one data argument available, but since it's a
void *, you
can use a struct with your handle and the opcode :).

> From Dave Hansen, select INPUT_SPARSEKMAP to fill the dependency.
>
> These patches are available in the git repository at:
>  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git ideapad-laptop
>
> Ike Panhc (7):
>  ideapad: add platform driver for ideapad
>  ideapad: let camera power control entry under platform driver

Maybe you could document that ? See
Documentation/ABI/testing/sysfs-platform-* files.

>  ideapad: add hotkey support
>  ideapad: select INPUT_SPARSEKMAP
>  ideapad: add markups, unify comments and return result when init
>  ideapad: pass ideapad_priv as argument (part 1)
>  ideapad: pass ideapad_priv as argument (part 2)
>
>  drivers/platform/x86/Kconfig          |    1 +
>  drivers/platform/x86/ideapad-laptop.c |  255 ++++++++++++++++++++++----------
>  2 files changed, 176 insertions(+), 80 deletions(-)


-- 
Corentin Chary
http://xf.iksaif.net
