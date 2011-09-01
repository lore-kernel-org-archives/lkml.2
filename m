Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1IAS46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 14:56:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55752 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652Ab1IAS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 14:56:57 -0400
Date: Thu, 1 Sep 2011 19:55:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Earl Chew <echew@ixiacom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <andi@firstfloor.org>, <oleg@redhat.com>
Subject: Re: [ PATCH 1/1 ] coredump: use current->group_leader->comm instead
 of current->comm
Message-ID: <20110901195554.667c5e58@lxorguk.ukuu.org.uk>
In-Reply-To: <4E5FBA73.2050108@ixiacom.com>
References: <4E5FBA73.2050108@ixiacom.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011 10:01:39 -0700
Earl Chew <echew@ixiacom.com> wrote:

> Change corepattern %e and %E to use current->group_leader->comm instead of current->comm.

Which might break stuff.

> A core dump can be triggered from any task in a group, and substituting current->comm
> means that the name of the core file for a process can vary in surprising ways.

Which some people may well be using

> Using current->group_leader->comm makes the name of the core file more consistent
> for a process when used with %e or %E.

In your view, but there is a better way to do this - add a new case and
letter for the behaviour you want. That way you don't break anyone elses
defaults and expectation and people can set a corepattern dependant upon
the group leader.

Alan
