Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0JYVD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:03:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810Ab0JYVD4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <4CC5DCBB.1070505@kernel.org>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
 <19653.55494.240658.165153@quad.stoffel.home> <4CC5DCBB.1070505@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 13:55:09 -0700
Message-ID: <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
To: "J.H." <warthog9@kernel.org>
Cc: John Stoffel <john@stoffel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 12:38 PM, J.H. <warthog9@kernel.org> wrote:
>
> I'll second both points.  If IMA is disabled, but compiled in, it *HAS*
> to consume 0 resources.

I disagree. First off, this isn't actually true. Look at things like
quota support: it eats more memory in the inode than IMA does after
this patch-series (two pointers), and most people don't use that
either. So the "it must use zero extra memory" is bogus - it's a
balance between simplicity of the code and memory use.

Secondly, right now we're in the situation that IMA just sucks. Sucks
with all capital letters, in fact. This patch-series may not be
perfect, but it's _so_ much better than the current situation that I
don't really see why people are so adamantly negative about it.

Please do feel free to be constructive about it, and I'm sure there
are ways to improve even more, but right now "constructive" is not
what the objections seem to be.

                            Linus
