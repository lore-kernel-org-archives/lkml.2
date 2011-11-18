Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1KRUf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1KRUf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:35:56 -0500
Date: Fri, 18 Nov 2011 15:35:49 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au, jcm@jonmasters.org
Subject: depmod memory usage.
Message-ID: <20111118203548.GA17761@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au,
	jcm@jonmasters.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled out an older laptop last night to test something, and built
a kernel on it.  When I did the make install part, the machine almost
ground to a halt.

It turned out that depmod used at peak 1.7GB of memory, (the laptop only had 1GB,
so it was swapping to the point of locking up interactivity for minutes
at a time).  It took an hour to complete.

The config file is pretty pathological (it's a distro build, so tons of
modules -- http://codemonkey.org.uk/junk/fedora-config-x86-64)

It's been a while since I built on a machine with this amount of memory,
but it seems that depmod has taken a big step backwards as it used to
cope with this just fine.

This is with the m-i-t that shipped in Fedora 16 (3.16)

	Dave

