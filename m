Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2FNQNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab2FNQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:13:43 -0400
Date: Thu, 14 Jun 2012 12:13:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: 3.5.rc2 tty buffering bug ?
Message-ID: <20120614161331.GA29687@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found something odd that happens with redirection.

this code...



#include <stdio.h>

void main()
{
	printf("begin\n");

	if (fork() != 0)
		printf("child\n");
	else
		printf("parent\n");

	printf("end\n");
}

usually exits before the child gets to print anything, so stdout looks like..

begin
parent
end

but when redirected to a file, sometimes it prints what we expect, but other times
(if the child exits first) it seems to print..

begin
child
end
begin
parent
end


How does 'begin' get printed a second time ?

	Dave

