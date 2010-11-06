Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0KFSan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:30:43 -0400
Received: from nm29-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.236]:22419 "HELO
	nm29-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752675Ab0KFSal convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:30:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 992858.88936.bm@omp1022.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=j64CwAxO9u0JuElwyUpL3BBIfvLK3F4jkzXNhclKuDcxQxLH/cGiwuyLP6IcvO27mbfIygnDr3r9vcFAZC2Q32miRf/UC84zrB9Jfa4pnkuWRo3mZkuC7mHQ3RtRTXKqgHk1OLQTic+STcMs+7UUmKk/DxuHCv8Gg/Wmd/lbk4I=;
Message-ID: <502882.59497.qm@web180306.mail.gq1.yahoo.com>
X-YMail-OSG: _JHUYckVM1nsuzaXihwINGUh9.aDzr_0fa9CWcEFxlDs9Mk
 rHUWf9MAQ77o9alP5P.QjS3i.c_bDEqw2wv8rafMjK8JAVLUkBRxD8jnxgL2
 fPGN14mSf3U9xEtu5f_RB_n7mfqdw9SBJBz.5jhIlBWqcxQgh59j_r577F61
 Fu9IOmmbt8RM6JyuKqpe_SB4ql8cTidcZuwNlBCWMtFz8c7tnbQ_7ZwCSny8
 3rW1prhXheBbhCEH7HqiBl9Xgqa4mhN3y2JZu7Wif8aAy7mfr4OF0RhtS_gn
 Bvwy4yalhKAwLO66yemE1jEGtabLgstwNbGQfM4PPlI4bvYaVAw73DHjHFsj
 omg3dfpUtUnugp0R.edc4XRvtMVZGmcbMevGTraQ-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Sat, 6 Nov 2010 11:30:40 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usb: core: fix information leak to userland
To: Vasiliy Kulikov <segooon@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oliver@neukum.org>, Andi Kleen <ak@linux.intel.com>,
        Chris Frey <cdfrey@foursquare.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1011061419490.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 11/6/10, Alan Stern <stern@rowland.harvard.edu> wrote:

> Are you sure that adding an initializer
> like this will zero out the 
> padding bytes?  It might be safer just to call
> memset.

ISTR the C standard says things get initted to
zero in this case too ... and that compilers will
as a rule use memset to do it.  One could look
at the generated code to make sure of that.

There's certainly a fair amount of code I've seen
that uses runtime initializers like that, to zero
memory.  I can't believe i's _all_ broken!  ;)

- Dave


