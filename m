Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1EMFxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:53:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47565 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab1EMFxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:53:49 -0400
Date: Fri, 13 May 2011 07:53:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: question about drivers/isdn/hisax/st5481_init.c
Message-ID: <Pine.LNX.4.64.1105130748060.9190@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function probe_st5481 allocates an adapter value using kzalloc, adds 
it to adapter_list, and then performs various initialization operations, 
which may fail.  adapter_list is a static variable that is never otherwise 
referenced in the file.  There is a list_del that removes the adapter from 
the list in the function disconnect_st5481.  The presence of the adapter 
on the list makes it possibly unsafe to free adapter in the failure cases.

Could the list just be removed, if it is not being used anywhere?

Or if the list should be kept because it is useful or it is planned to be 
useful in the future, could the insertion into the list be moved to the 
end of the function, after the potentially failing operations, so that 
adapter can be freed when a failure occurs?

julia
