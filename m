Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2HSHxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:53:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44399 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2HSHxI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Sun, 19 Aug 2012 03:53:08 -0400
Message-Id: <5030A96F020000780008A1F1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Sun, 19 Aug 2012 08:53:03 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <andi@firstfloor.org>, <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 03/74] sections: Make external kallsyms tables
 __visible
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-4-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-4-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 08/19/12 5:02 AM >>>
>-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
>-extern const u8 kallsyms_names[] __attribute__((weak));
>+extern __visible const unsigned long kallsyms_addresses[] __attribute__((weak));
>+extern __visible const u8 kallsyms_names[] __attribute__((weak));
 
Shouldn't we minimally aim at consistency here:
- all attributes in a one place (I personally prefer the placement between type
  and name, for compatibility with other compilers, but there are rare cases -
  iirc not on declarations though - where gcc doesn't allow this)
- not using open coded __attribute__(()) when a definition (here: __weak) is
  available, or alternatively open coding all of them (__attribute__((weak, ...)))?

Jan

