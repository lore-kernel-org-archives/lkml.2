Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0CVTCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:02:17 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33391 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0CVTCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:02:15 -0400
Message-ID: <4BA7BEB3.9040105@davidnewall.com>
Date: Tue, 23 Mar 2010 05:32:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kyle Hubert <khubert@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SysV IPC message queues
References: <9a158e2e1003211928y37d3bbfnac068f200128ddb6@mail.gmail.com> <9a158e2e1003220146p463e35b6u2615695ae9ddc1b9@mail.gmail.com>
In-Reply-To: <9a158e2e1003220146p463e35b6u2615695ae9ddc1b9@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle,

Processes do not open nor close message queues, rather they place 
messages on and fetch them from queues.  Let me say this again: you do 
not open a queue like you must for a file, but go directly to the 
equivalent of read and write.  There is no refcount to indicate how many 
processes are "using" a queue, although there may be one indicating how 
many are actively waiting to receive a message.  Removing a queue when 
that count reaches zero would be quite wrong because a process stops 
waiting as soon as it receives a message; so the count would be zero 
more often than not.

Do not allow IPC_PRIVATE to lead you into false understanding of what a 
message queue is.  IPC_PRIVATE does not cause creation of a private 
queue, as indicated in msgget(2): "The name choice IPC_PRIVATE was 
perhaps unfortunate, IPC_NEW would more clearly show  its  function."  
Queues are not accessed by key but by id.  You do not need to know the 
key for a queue to access it, neither do you need to use msgget(2) to 
find a queue's id.

So, no, sorry, but your idea must be rejected.

David
