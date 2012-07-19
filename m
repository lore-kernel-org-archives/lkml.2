Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2GSPo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:44:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58254 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2GSPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120719152618.GD16873@home.goodmis.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com> <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jul 2012 08:43:58 -0700
X-Google-Sender-Auth: hTKFHifvr5KM7J1BHPs7IJAgF-0
Message-ID: <CA+55aFzTq2CNxPa3X+N=biFgifrmWbeWQJZLVFAFdySWXQCKXg@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 8:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Side note, and this is for the 1%. If you want a true minconfig for your
> system, ktest can do that for you.

Try it, it's actually much harder than it seems. Like allmodconfig, it
handles the minimum hardware well, but it tends to handle the subtle
issues really badly.

Many config options cause *very* subtle failures that are almost
impossible to see. Like firewalls not loading correctly (and leaving
the machine completely open), or just stuff that you didn't happen to
test (USB sticks, printers, certain programs) not working. Not having
the right audit options will make things still "work", but you'll get
warnings at bootup, and who knows what that causes etc etc.

These kinds of things are exactly why I'd like to have a distro config.

               Linus
