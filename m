Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474Ab0KQWSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:18:54 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47930 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab0KQWSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:18:53 -0500
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering
 writeback
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
In-Reply-To: <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	 <1289996638-21439-4-git-send-email-walken@google.com>
	 <20101117125756.GA5576@amd> <1290007734.2109.941.camel@laptop>
	 <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 23:18:46 +0100
Message-ID: <1290032326.2109.1281.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:05 -0800, Michel Lespinasse wrote:
> 
> Really, my understanding is that not pre-allocating filesystem blocks
> is just fine. This is, after all, what happens with ext3 and it's
> never been reported as a bug (that I know of).
> 
fwiw I'm perfectly fine with it

> If filesystem people's feedback is that they really want mlock() to
> continue pre-allocating blocks, maybe we can just do it using
> fallocate() rather than page_mkwrite() callbacks ? 

Sounds sensible..
