Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0JZOIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:08:40 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:48026 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0JZOIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:08:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19654.57503.448600.856000@quad.stoffel.home>
Date: Tue, 26 Oct 2010 10:07:27 -0400
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.H." <warthog9@kernel.org>, John Stoffel <john@stoffel.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<19653.55494.240658.165153@quad.stoffel.home>
	<4CC5DCBB.1070505@kernel.org>
	<AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Mon, Oct 25, 2010 at 12:38 PM, J.H. <warthog9@kernel.org> wrote:
>> 
>> I'll second both points.  If IMA is disabled, but compiled in, it *HAS*
>> to consume 0 resources.

Linus> I disagree. First off, this isn't actually true. Look at things
Linus> like quota support: it eats more memory in the inode than IMA
Linus> does after this patch-series (two pointers), and most people
Linus> don't use that either. So the "it must use zero extra memory"
Linus> is bogus - it's a balance between simplicity of the code and
Linus> memory use.

Quotas are useful in a much more general sense for managing a limited
resource (disk space) and for a larger audience as well.  And hey,
let's target quotas next!  *grin*

Linus> Secondly, right now we're in the situation that IMA just
Linus> sucks. Sucks with all capital letters, in fact. This
Linus> patch-series may not be perfect, but it's _so_ much better than
Linus> the current situation that I don't really see why people are so
Linus> adamantly negative about it.

I'm negative about it because I forsee very limited applicability to
normal day to day use of Linux in my work.  Quotas I use every day.  

Linus> Please do feel free to be constructive about it, and I'm sure
Linus> there are ways to improve even more, but right now
Linus> "constructive" is not what the objections seem to be.

Sorry, will certainly try to be more positive about my objections to
this system.  

Mostly I'd really like to just see:

       - documentation
       - Kconfig updated to default to N.

John
