Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0GMSM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:12:28 -0400
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:43020 "EHLO
	mrelay2-v.mgt.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042Ab0GMSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:12:26 -0400
X-Originating-IP: 217.70.178.39
X-Originating-IP: 74.107.143.84
Date: Tue, 13 Jul 2010 11:12:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Chris Li <christ.li@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH 2/2] parser: define __builtin_unreachable
Message-ID: <20100713181212.GB20289@feather>
References: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
 <1278751162-10053-2-git-send-email-jslaby@suse.cz>
 <20100710090705.GA14881@feather>
 <AANLkTimf821jhfhU-Rsj7xa2S4EzuP23weoUSZVWsD2u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimf821jhfhU-Rsj7xa2S4EzuP23weoUSZVWsD2u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:52:48AM -0700, Chris Li wrote:
> On Sat, Jul 10, 2010 at 2:07 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > __builtin_unreachable has special semantics beyond just a function.
> > This definition will suffice to allow compilation, but
> > __builtin_unreachable should have the same effect in sparse that it does
> > in GCC: mark the point (and the remainder of the basic block) as
> > unreachable.  Something like the mechanism used for handling noreturn
> > would work here as well; declaring the function to have attribute
> > noreturn would probably have almost the right semantics.
> >
> 
> The attribute noreturn will apply to the whole function. The function
> NEVER returns.
> __builtin_unreachable only apply to current basic block. e.g. some
> error handling path like panic. The function can still return a value on the
> normal path. It has different meaning than attribute noreturn. So I don't think
> automatically give the function noreturn attribute is the right thing to do.

No, I didn't mean that using __builtin_unreachable should mark the
function calling it as noreturn.  I meant that as an approximation to
the right behavior, __builtin_unreachable *itself* could have attribute
noreturn.

- Josh Triplett
