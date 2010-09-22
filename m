Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0IVTqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:46:11 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44420 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab0IVTqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:46:10 -0400
Message-ID: <4C9A5CFA.7080106@interlog.com>
Date: Wed, 22 Sep 2010 15:46:02 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Knibbs <markk@clara.co.uk>
Subject: [ANNOUNCE] ddpt, yet another dd variant
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddpt is yet another variant of the venerable Unix
dd command line utility. Some features found in
ddpt which are not found in the current (GNU) dd
implementation:

   - sparse writing (i.e. don't write buffer if all zeros)
   - write sparing (i.e. don't write buffer if already same
     as destination)
   - resume (after the copy has been interrupted)
   - trim on output of copy, self trim (pt interface only)
   - send output to a second file (see 'of2=' option)
   - access devices directly via pass-through interface,
     bypassing file system
   - accept numeric command line arguments in hexadecimal
   - explicit controls over how much data is read into the
     copy buffer and then written to output (separate from
     the logical block sizes of any device involved)

For those familiar with the sg3_utils package, ddpt is
a rewrite of the sg_dd utility. ddpt removes the special
support for the SCSI generic (sg) driver features found in
sg_dd. This allows ddpt to use other SCSI pass-throughs
such as bsg in Linux plus the SCSI pass-throughs found in
FreeBSD, Solaris and Windows.

ddpt has been almost 2 years in the making. Every time I
prepared to release it, the most frequent contributor to
this project, Mark Knibbs, would have another feature
request or correction in my Inbox. Time to get it out the
door.

Note that ddpt is not meant to be an exact replacement for
dd. ddpt changes some dd defaults. For example, if the output
file (i.e "of=") is not given, ddpt does not output anything;
dd will send the output to stdout which is not much fun if
the input is a terabyte of binary data.


The initial release version number is 0.91 . For more
information and downloads see:
     http://sg.danny.cz/sg/ddpt.html

A release announcement has been sent to freshmeat.net .

Doug Gilbert
