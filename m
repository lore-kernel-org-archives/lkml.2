Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab1IATXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab1IATXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:23:54 -0400
Subject: Re: [PATCH 01/24] fix default __strnlen_user macro
From: Mark Salter <msalter@redhat.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 15:23:51 -0400
In-Reply-To: <4E5EE5DB.3030101@gmail.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
		 <1314826019-22330-2-git-send-email-msalter@redhat.com>
		 <4E5EC3FE.10307@gmail.com> <1314841084.2344.113.camel@deneb.redhat.com>
	 <4E5EE5DB.3030101@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1314905032.1439.29.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:54 +1000, Ryan Mallon wrote:
> It should either be changed as I suggested, or the comment in uaccess.h 
> should be updated to reflect the actual behaviour of the function 
> (stating that it returns n + 1 in the case where n is reached). Either 
> way, its probably worth doing a quick check through the arch specific 
> versions to see what their behaviour really is. It looks like there are 
> potentially some subtle bugs at the callsites.

I think commenting it in uaccess.h is the only sane way to go. Changing
the semantics means changing all the arch-specific versions, most of
which are asm code and changing most, if not all callsites. All of the
arch-specific versions I looked at include the NULL count.

--Mark



