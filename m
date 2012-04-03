Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2DCQZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:25:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DCQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:25:53 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [REGRESSION] NFSv4: open(O_TRUNC) hangs
Date: Tue, 03 Apr 2012 18:26:17 +0200
Message-ID: <87d37osrx2.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this test program hangs on latest git.

Thanks,
Miklos
---

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	int res;
	char *name = argv[1];
	int fd;

	unlink(name);
	fd = creat(name, 0644);
	write(fd, "123", 3);
	close(fd);
	close(open(name, O_RDONLY | O_TRUNC));

	return 0;
}
