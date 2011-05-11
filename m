Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1EKWkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:40:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43701 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab1EKWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:40:11 -0400
Message-ID: <4DCB1044.6030505@landley.net>
Date: Wed, 11 May 2011 17:40:04 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Don't understand comment in arch/x86/boot/compressed/misc.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It talks about when decompression in place is safe to do:

 * Getting to provable safe in place decompression is hard.
 * Worst case behaviours need to be analyzed.
...
 * The buffer for decompression in place is the length of the
 * uncompressed data, plus a small amount extra to keep the algorithm safe.
 * The compressed data is placed at the end of the buffer.  The output
 * pointer is placed at the start of the buffer and the input pointer
 * is placed where the compressed data starts.  Problems will occur
 * when the output pointer overruns the input pointer.
 *
 * The output pointer can only overrun the input pointer if the input
 * pointer is moving faster than the output pointer.  A condition only
 * triggered by data whose compressed form is larger than the uncompressed
 * form.

You have an output pointer at a lower address catching up to an input
pointer at a higher address.  If the input pointer is moving FASTER
than the output pointer, wouldn't the gap between them grow rather
than shrink?

The concern seems to be about COMPRESSING in place, rather than
decompressing...?

Rob
