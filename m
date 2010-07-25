Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0GYImu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:42:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61462 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0GYIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j7IWnmg7ltiKumTpcfAGYNGlUhlDCOn3vzvvZBqz5Dl9nLTteiKyDbUUgklf11ugHs
         m7Qc/UzO4CccQsNMn3YEA+nEVqtmG0SvgOrUa+CLaNpqQaSMESGxXL9v+6wXuFTvCj9b
         ubxKfbmkbvNVO7I6a4Of6RIKynPPTD6SAedTE=
MIME-Version: 1.0
In-Reply-To: <20100723131034.GA6618@joi.lan>
References: <20100720191923.GA11056@joi.lan>
	<20100722172039.e935c67d.akpm@linux-foundation.org>
	<20100723131034.GA6618@joi.lan>
Date: Sun, 25 Jul 2010 18:42:48 +1000
Message-ID: <AANLkTimQZ6_+o=3pGa6hGbeFU99RMPFRmO+ndMZDHZMS@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v2] vga16fb: refuse to load in face of other 
	driver controlling primary card
From: Dave Airlie <airlied@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nouveau@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 11:10 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Thu, Jul 22, 2010 at 05:20:39PM -0700, Andrew Morton wrote:
>> On Tue, 20 Jul 2010 21:19:23 +0200
>> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
>>
>> > We don't want vga16fb to mess with hardware initialized by other driver.
>> > Detect it and refuse to load.
>> > It fixes nouveau interrupt storm on some machines.

Can't we keep this all inside vga16fb? just have it walk PCI tree
looking for a primary VGA card, and if it has a driver bound, just
refuse to bind.

Dave.
