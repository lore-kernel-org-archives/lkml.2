Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2CLRdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:33:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54668 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2CLRdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:33:50 -0400
Message-ID: <1331314389.18960.1.camel@twins>
Subject: RE: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
From: Peter Zijlstra <peterz@infradead.org>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Date: Fri, 09 Mar 2012 18:33:09 +0100
In-Reply-To: <9774516974AF5F4C8A2C3C69CD34123320369E69@G9W0755.americas.hpqcorp.net>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
	 <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
	 <20120309171711.GI24378@redhat.com>
	 <9774516974AF5F4C8A2C3C69CD34123320369E69@G9W0755.americas.hpqcorp.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 17:28 +0000, Mingarelli, Thomas wrote:
> Can I register for more than one type? Like NMI_UNKNOWN | NMI_DIE (or
> something like that)?

There's only NMI_LOCAL and NMI_UNKNOWN, and you can only use NMI_LOCAL
if you can tell you generated the NMI. See it as one massively shared
interrupt line.

The NMI_UNKNOWN handler is basically the handler of last resort for
those that cannot multiplex the line, hence the restriction of only
having one.
