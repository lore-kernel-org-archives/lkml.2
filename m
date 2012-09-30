Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab2I3SDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 14:03:03 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48220 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab2I3SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 14:02:54 -0400
Date: Sun, 30 Sep 2012 20:02:40 +0200
From: Alessandro Rubini <rubini@unipv.it>
To: jrnieder@gmail.com
Cc: gjthill@gmail.com, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, 607242@bugs.debian.org
Subject: Re: [PATCH v2] psmouse: mitigate failing-mouse symptoms
Message-ID: <20120930180240.GA31164@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120930174353.GA29129@elie.Belkin>
References: <20120930174353.GA29129@elie.Belkin>
  <4D2A3008.3000609@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this would be less controversial if the run-time default were
> to disable the feature.

Yes, that's the common sensible path to new little-tested features.
As you say, it may become enabled by default over time.

Then, I think it would be good to have a specific sub-structure for
this stuff. It would allow this:

  +       psmouse->err_log_base = 0;
  +       psmouse->interval_base = 0;
  +       psmouse->hotio_log_base = 0;
  +       psmouse->err_log_counter = 0;
  +       psmouse->interval_pkts = 0;
  +       psmouse->hotio_log_counter = 0;

to be replaced with a memset. I also think it would make it clearer
what these are:

  +       unsigned long interval_base;
  +       unsigned long interval_pkts;
  +       unsigned long hotio_log_base;
  +       unsigned long hotio_log_counter;
  +       unsigned long err_log_base;
  +       unsigned long err_log_counter;

to the casual reader.

This is only a suggestion, though.

thanks
/alessandro
