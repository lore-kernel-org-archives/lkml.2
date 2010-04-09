Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0DINLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:11:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48316 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743Ab0DINLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:11:19 -0400
Date: Fri, 9 Apr 2010 14:15:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schnell <mschnell@lumino.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
Message-ID: <20100409141518.0dbe7050@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBF2351.3040506@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>
	<4BBDC7D4.6040301@lumino.de>
	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
	<4BBF0784.2060002@lumino.de>
	<20100409125426.5bc200da@lxorguk.ukuu.org.uk>
	<4BBF2351.3040506@lumino.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you think it could be done with NIOS: using store ordering, how can I
> implement a  pthread_mutex_..() workalike ?

Lamport's Bakery is the classic algorithm for doing this. It has very
minimal assumptions about visibility of writes and the order they are
seen so should certainly work uniprocessor and may work SMP depending
upon the cache coherency rules.

It doesn't scale well to large numbers of threads however.

Alan
