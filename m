Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab0DFS0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:26:02 -0400
Received: from claw.goop.org ([74.207.240.146]:55799 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab0DFSZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:25:56 -0400
Message-ID: <4BBB7CA3.2060802@goop.org>
Date: Tue, 06 Apr 2010 11:25:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dmitry Torokhov <dtor@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com>
In-Reply-To: <4BBB622F.4070501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 09:32 AM, Avi Kivity wrote:
> Yeah.  If we wanted commonality, we could make a balloon_core.c that 
> contains the common code.  IMO that's premature, but perhaps there's 
> some meat there (like suspend/resume support and /proc//sys interface).

I think it would be useful to have common:

   1. User and kernel mode ABIs for controlling ballooning.  It assumes
      that the different balloon implementations are sufficiently
      similar in semantics.   (Once there's a kernel ABI, adding a
      common user ABI is trivial.)
   2. Policy driving the ballooning driver, at least from the guest
      side.  That is, some good metrics from the vm subsystem about
      memory pressure (both positive and negative), and something to
      turn those metrics into requests to the balloon driver.

1) is not a huge amount of code, but something consistent would be 
nice.  2) is something we've been missing and is a bit of an open 
question/research project anyway.

     J
