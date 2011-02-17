Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1BQXTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:19:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46454
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab1BQXTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:19:15 -0500
Date: Thu, 17 Feb 2011 15:19:51 -0800 (PST)
Message-Id: <20110217.151951.242142034.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
References: <20110217.142320.102554706.davem@davemloft.net>
	<AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
	<AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 15:08:52 -0800

> Where in gcc is the alignment expansion logic? I'd like to see what
> the rules are, just for my own perverse satisfaction.

The magic that overrides the alignment various cases is in the x86
specific code:

gcc/config/i386/i386.c

ix86_data_alignment() and ix86_local_alignment()
