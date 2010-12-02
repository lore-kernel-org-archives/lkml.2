Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0LBXCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:02:55 -0500
Received: from 1wt.eu ([62.212.114.60]:48311 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab0LBXCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:02:55 -0500
Date: Fri, 3 Dec 2010 00:02:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: Stephane Bakhos <nuitari@nuitari.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Infinite listens for haproxy in /proc/net/tcp
Message-ID: <20101202230245.GA29279@1wt.eu>
References: <Pine.LNX.4.64.1012021313080.25944@anvil.nuitari.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1012021313080.25944@anvil.nuitari.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 02, 2010 at 01:18:36PM -0500, Stephane Bakhos wrote:
> This happens whether the file is read directly, or using netstat.
> It looks like haproxy has millions of LISTEN.

I think what you see are not LISTEN sockets but mostly TIME_WAIT.

> We've tried to see if there is a definitive count, but after 20 minutes of 
> running cat /proc/net/tcp we gave up. This is an intermittent problem.

I've been used to experience this on systems which process connections
at higher rates than netstat can output them. Thus, during the time it
takes to netstat to output a given number of connections, new ones
manage to complete the list. I've not tested on 2.6.36 yet, but this
has basically always been the case for me for a very long time, and as
such, I only use ss to display connections. I've recently discovered
that some versions of netstat use netlink to dump the socket list, so
on such versions it would not be an issue.

> According to ss, there is about 5500 connections running on the system.

What normally counts is the rate at which they're refreshed.

Regards,
Willy

