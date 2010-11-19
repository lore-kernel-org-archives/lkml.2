Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0KSJGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:06:50 -0500
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:13840 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752039Ab0KSJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 04:06:47 -0500
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Fri, 19 Nov 2010 18:07:05 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <1290010595.3777.0.camel@jlt3.sipsolutions.net> <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
In-Reply-To: <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191807.06013.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 18 2010 08:11:18 Bob Copeland wrote:
> On Wed, Nov 17, 2010 at 11:16 AM, Johannes Berg
> 
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2010-11-17 at 17:28 +0900, Bruno Randolf wrote:
> >> I understand that this could be more efficient, but if it matters or not
> >> - honestly, I don't know. Can a more knowledgeable person than me
> >> comment on this?
> > 
> > Yes, it does matter -- think of an embedded MIPS board running at 500MHz
> > and trying to push 11n speeds.
> 
> I assume the number of samples (weight) is the more
> important tunable.  One option is you can require factor
> to be a power of two that is much larger than weight,
> then at least you can store factor/weight precomputed
> and multiply by it instead of doing a divide in ewma_add.
> Then ewma_get can also just be a shift as well.

Hmm, maybe I suck in mathemathics, but I don't see a way to do that given the 
formula:

(((internal * (weight - 1)) + (val * factor)) / weight

bruno
