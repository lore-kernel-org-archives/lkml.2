Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0FNGeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:34:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35089 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0FNGeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hgS39rM3C2eRqvGDXegDmAw75dtKTFaWXIAO2yb1zLAv4t22tHu9CjpChz+W8957vD
         dga0fm+LmFr4KaO6e4kLssj3TwG8UXAjSXaQXj/RqriJhGfOAA5D7WFOOZcjs8btcLNh
         djOfZMmtl6VqRABomPrh0OHO8IUtXpzrh3iVk=
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 00:34:12 -0600
Message-ID: <AANLkTik_lsycuZNpCiPA7L594bhwSjR2XQg9VZ3CIKEB@mail.gmail.com>
Subject: 4K Pageable Stacks a MUST
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been running down bugs on the MDB Debugger on a 4 processor AMD
Opteron System and have discovered that processors 1-X (other than 0)
use a buttload of stack space when all the spinlock debgguging checks
are turned on -- way too much memory and the systenter_past_esp panic
shows up a lot.  NetWare at one point instrumented the ability to page
map an extra 4K of memory up to 16K (then release it when the stack
shrunk back to a smaller usage footprint).  I think for debugging and
just general usage you should enable a 16K pagable limit with 4K
stacks for debuggers and such or just to stop a lot of dump traps.

It's getting to the point where 8K wont be enough when people need to
debug spinlocks and rcu locks and other types of breakage.  Would not
be hard to instrument.

Jeff
