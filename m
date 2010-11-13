Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0KMWvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:51:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34685 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0KMWvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:51:49 -0500
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Peter Zijlstra <peterz@infradead.org>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 23:52:03 +0100
Message-ID: <1289688723.2109.396.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 21:49 +0800, Cypher Wu wrote:
> I'm using TILEPro and its rwlock in kernel is a liitle different than
> other platforms. It have a priority for write lock that when tried it
> will block the following read lock even if read lock is hold by
> others. 

That's a bug, rwlock_t must most definitely be a read preference lock,
there's tons of code depending on that.
