Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab0IIWkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:40:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41427 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932901Ab0IIWjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:39:55 -0400
Date: Fri, 10 Sep 2010 00:00:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 2/2] posix clocks: introduce a sysfs presence.
Message-ID: <20100910000008.1483fdd7@lxorguk.ukuu.org.uk>
In-Reply-To: <84124d2479b8967cac2b35f852fc0fcae6ad9444.1283504065.git.richard.cochran@omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
	<84124d2479b8967cac2b35f852fc0fcae6ad9444.1283504065.git.richard.cochran@omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 11:30:13 +0200
Richard Cochran <richardcochran@gmail.com> wrote:

> This patch adds a 'timesource' class into sysfs. Each registered POSIX
> clock appears by name under /sys/class/timesource. The idea is to
> expose to user space the dynamic mapping between clock devices and
> clock IDs.

This is intrinsically racy so not a good API at all.

By the time I have acquired an id from sysfs it may have been re-issued
or changed.

POSIX habit of enumerating objects not properties of objects is one of
the brain dead aspects of POSIX that we should have nothing to do with.

Also we have existing time sources that don't follow the poxix clock
model - I can open /dev/rtc and I can open the hpet and so on.

I like /sys/class/time* *but* you need to be able to open the sysfs
device and apply operations to it in order for it to work when your closk
can be dynamically created and destroyed and to get a sane Unix API.

To start with try applying permissions to clock sources via the POSIX
API. That is something that will be required for some applications.

I need to be able to open sys/clock/foo/something and get a meaningful
handle. Sure it's quite likely the operations it supports are related to
the POSIX timer ops.

Alan
