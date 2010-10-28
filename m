Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab0J1Vnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:43:39 -0400
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:34952 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933157Ab0J1Vnd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:43:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WgdetHhuK5EwzDDygQauywfJKplWKwBi45jY2uYRooLr8j5EsJrSwgfzZX6TTo0cfW0nS5vFay2w/ycXgSTfgVfiO7sd0vU0GJLSEOrwA3JczKU8n/cgGnlu/6QRLUzovnRRBZwbxmX+0oPM20UMALVxB8HvmIraHsetaTqErys=;
Message-ID: <807665.54188.qm@web31802.mail.mud.yahoo.com>
X-YMail-OSG: 3QtLcjsVM1k7qiBfPj4_UIrK6MKQqsCE9NkJqHKUw2za.2R
 0i.q4bnhsX0AtYdRI0W6IW8NoNNRAqN2UuXnEuboTwn6IJ_fQibD4lKeQN4r
 ooh_14p845_73YztWwXcrI3nGGBD_fnNkY2HtcGXuSQzHP5ueenhDSpWoBBt
 q6BnVHyK.EKFocJuam1uHkX0ToCJtegpLpFjS5eF6gSS_3.qGm9PKrCWEbxt
 Q2KmcLIqkRoNHkg7FIwZVh7vOcQLf8dDbugxDUikFX54rAMK0hFAWLAGIY8a
 Uy7fMw9ySOINaWGnjfmLbzfHaVeoklzbi5qWU7EydBtfJdq4I78viN4J2LS5
 EDE_WRzehE1FAfeMJTp7vKtRLV7oyam_oaA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 28 Oct 2010 14:43:31 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20101028204101.GA22785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 10/28/10, Greg KH <greg@kroah.com> wrote:
> I'm sorry, but can you explain this a bit more?  I
> really don't
> understand why this change is necessary.

It isn't necessary (like water or food, etc). It reflects much closer what
really is happening under the hood. Having a software abstraction
(implementation) representing the hw or the physical function much closer,
allows for much more versatile manipulation.

For example, if you would like to implement sending TMFs and receiving
their Responses, you'd do that on the Command and Status pipes. So you can
allocate an URB at the "cmd_urb" (meaning "command pipe urb") and on the
"status_urb" (meaning "status pipe urb"). Before this patch this was called
"sense_urb" which reflected what the type of IU but not the pipe, all the
while it was being allocated for the Status pipe. A good infrastructure
is a reusable infrastructure. This patch properly renames some macro
definitions and variables in order to allow for some of the infrastructure
of the driver to be reused in order to send other IUs.

