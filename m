Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab0FKUWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:22:47 -0400
Received: from lirone.symas.net ([64.71.152.235]:40014 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab0FKUWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:22:46 -0400
Message-ID: <4C129B0A.8080809@symas.com>
Date: Fri, 11 Jun 2010 13:22:34 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXTPROC, telnetd LINEMODE, revisited
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org> <4C121B4C.2000702@symas.com>
In-Reply-To: <4C121B4C.2000702@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu wrote:
> Andi Kleen wrote:
>> e.g. history management is definitely something that should not
>> be done in the kernel.

I must be going senile or something. You're absolutely right of course. I just 
dug up my old telnet patches from 1989 that implemented the command history in 
the client. All that we need today is a patch for GNU readline that makes it 
mostly do nothing when EXTPROC mode is set on the tty.

We still need to be able to forward on <TAB> of course. We can define 
additional forwarding characters using VEOL or VEOL2, but I think they also 
have the semantic of terminating the input line, which is not what we want 
here. Since they are so rarely used for their original purpose, would it be a 
terrible thing to subvert them to this purpose, or can we just add a new VFWD 
character to the tty driver?

> I definitely wasn't trying to suggest that the management occur in the kernel.
> Only that some mechanism for telling the client to toggle the feature on or
> off would be useful.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
