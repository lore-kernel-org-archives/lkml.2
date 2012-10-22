Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2JVFCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:02:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59235 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2JVFCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <1350867440-6109-1-git-send-email-dmitry.torokhov@gmail.com>
References: <20121021073928.GV2616@ZenIV.linux.org.uk> <1350867440-6109-1-git-send-email-dmitry.torokhov@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Oct 2012 08:02:12 +0300
X-Google-Sender-Auth: hwqfkYGlP2vVM2NhnxZadx_VVN4
Message-ID: <CA+55aFyg_TtKn5ikYBm2i3uSRwjskY1Rowj3mNZ285hh8hKWDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] char_dev: pin parent kobject
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series looks good to me, and looks to fix the issue about as
cleanly as it can. Al, holler if you have any concerns, but I'm
planning on applying it ASAP,

            Linus

On Mon, Oct 22, 2012 at 3:57 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> In certain cases (for example when a cdev structure is embedded into
> another object whose lifetime is controlled by a separate kobject) it is
> beneficial to tie lifetime of another object to the lifetime of character
> device so that related object is not freed until after char_dev object is
> freed. To achieve this let's pin kobject's parent when doing cdev_add()
> and unpin when last reference to cdev structure is being released.
