Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1EYO6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:58:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab1EYO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105250945240.23309@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
 <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org> <alpine.DEB.2.00.1105240908100.25760@router.home>
 <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org> <alpine.DEB.2.00.1105250945240.23309@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 07:57:42 -0700
Message-ID: <BANLkTiksf8NJ40twt1nxp6oRAqNv45QeCQ@mail.gmail.com>
Subject: Re: SLUB regression in current Linus
To: Christoph Lameter <cl@linux.com>
Cc: James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 7:47 AM, Christoph Lameter <cl@linux.com> wrote:
>
> So simply return the object. In the debug case we do not need all the other
> processing that unlock_out: does.

So that patch looks like it should explain things.

But exactly why don't we need the ->tid update and the ALLOC_SLOWPATH
stats? Both of them would seem to be equally valid for the debug case.

                             Linus
