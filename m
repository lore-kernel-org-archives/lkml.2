Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0KBW5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:57:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44154 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0KBW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lZrsu/mm0nYDLKvRqDLOq43bBUvfUOOodOXn0u3wKHxUV3KoSqloNAc1qWcDs6f+LL
         iRefKfPi16giAiNyWDmWJcQAH5u0tBIjaD1q6nIDBR5jNhUqlXfHTlxARlEXAcq4PLei
         qix1k9trId0dJOFqFy1gXVV3ehmcYs2xE+Qm0=
MIME-Version: 1.0
Date: Tue, 2 Nov 2010 23:57:36 +0100
Message-ID: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
Subject: Bug in checkpatch.pl
From: Audun Hoem <audun.hoem@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have stumbled about a bug in checkpatch.pl while working on some
code in drivers/staging. It seems to get confused when confronted with
asterisks. For example, this snippe:

kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);

Here the asterisk is in it's binary form, obviously, and performs a
multiplication, however checkpatch reports this:

drivers/staging/frontier/alphatrack.c:772: ERROR: space prohibited
after that '*' (ctx:WxW)

So it's obviously thinking it's the unary operator, which should only
be preceded by a variable name or another unary operator such as ++.
