Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab1EYPpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:45:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab1EYPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jg371aaZCAY4GsAMpgc86IIhEDOiIiDr67wnp/KGVewsFOTbUkEqt926/qDLjyuVze
         iEYAjv9sb3bNoCoUfuV/e6sNI9P6/s0Wpa659fozndrhPYDB8XwWP0RT8thX8tqW4dNn
         OddgxIkS7unNMBsLKLIy52Q0d+tA8yEbkZGiI=
Subject: Re: SLUB regression in current Linus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1105251003150.23309@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
	 <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>
	 <alpine.DEB.2.00.1105240908100.25760@router.home>
	 <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org>
	 <alpine.DEB.2.00.1105250945240.23309@router.home>
	 <BANLkTiksf8NJ40twt1nxp6oRAqNv45QeCQ@mail.gmail.com>
	 <alpine.DEB.2.00.1105251003150.23309@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 17:45:41 +0200
Message-ID: <1306338341.2820.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 25 mai 2011 à 10:04 -0500, Christoph Lameter a écrit :
> On Wed, 25 May 2011, Linus Torvalds wrote:
> 
> > On Wed, May 25, 2011 at 7:47 AM, Christoph Lameter <cl@linux.com> wrote:
> > >
> > > So simply return the object. In the debug case we do not need all the other
> > > processing that unlock_out: does.
> >
> > So that patch looks like it should explain things.
> >
> > But exactly why don't we need the ->tid update and the ALLOC_SLOWPATH
> > stats? Both of them would seem to be equally valid for the debug case.
> 
> We always fall back to the slow path in the debug case. So the tid update
> is useless.

tid change is updated anyway at the end of deactivate_slab()


