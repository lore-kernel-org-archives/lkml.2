Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935701Ab0KQXLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:11:20 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59038 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935559Ab0KQXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:11:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EVY5lOoJf3YoJJG/TNmMQsnZfywBIfZvUB4M+ywZQlTF+fmILfOOw2LvemwHDjGVSo
         k0PnuUKcG4tRSoDalyOeViDN5NtG0wOEMmjyWYJ7rTPdBiy224jKcgeQfZ2cST1d1IuY
         +nqicwgJzJWITCSoqJjY/1VhI5amcmsbZsWfQ=
MIME-Version: 1.0
In-Reply-To: <1290010595.3777.0.camel@jlt3.sipsolutions.net>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	<20101112030035.28522.75318.stgit@localhost6.localdomain6>
	<20101116093743.GA21872@jm.kir.nu>
	<201011171728.06801.br1@einfach.org>
	<1290010595.3777.0.camel@jlt3.sipsolutions.net>
Date: Wed, 17 Nov 2010 18:11:18 -0500
X-Google-Sender-Auth: Sd0Tm3QbtOPVZtaOVzYho5ZPCuE
Message-ID: <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-11-17 at 17:28 +0900, Bruno Randolf wrote:
>> I understand that this could be more efficient, but if it matters or not -
>> honestly, I don't know. Can a more knowledgeable person than me comment on
>> this?
>
> Yes, it does matter -- think of an embedded MIPS board running at 500MHz
> and trying to push 11n speeds.

I assume the number of samples (weight) is the more
important tunable.  One option is you can require factor
to be a power of two that is much larger than weight,
then at least you can store factor/weight precomputed
and multiply by it instead of doing a divide in ewma_add.
Then ewma_get can also just be a shift as well.

-- 
Bob Copeland %% www.bobcopeland.com
