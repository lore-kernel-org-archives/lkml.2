Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0DWXzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:55:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35213 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0DWXzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:55:35 -0400
Date: Fri, 23 Apr 2010 18:55:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Documentation/credentials.txt
Message-ID: <20100423235532.GA17804@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the section 'ACCESSING ANOTHER TASK'S CREDENTIALS', the file
Documentation/credentials.txt says:

> A function need not get RCU read lock to use __task_cred() if it is holding a
> spinlock at the time as this implicitly holds the RCU read lock.

AIUI, that is not actually right any more, is it?  A spinlock does not
suffice as it does not necessarily imply an RCU read-side critical section
(anymore).  Of course the spinlock specifically protecting updates would
suffice, but that's not what this is saying.

Am I way off base?

thanks,
-serge
