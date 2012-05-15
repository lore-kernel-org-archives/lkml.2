Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2EOHxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:53:41 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:57400
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757111Ab2EOHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:53:40 -0400
Date: Tue, 15 May 2012 09:53:38 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: determining if a block erasure failed
Message-ID: <alpine.DEB.2.00.1205150944550.17750@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want the caller of erase_worker() to be aware if the erase block became
bad. Here is the relevant code at the end of erase_worker():

/* at this time, the erase has failed. err == -EIO */
        ubi_msg("mark PEB %d as bad", pnum);
        err = ubi_io_mark_bad(ubi, pnum);
        if (err)
                goto out_ro;

/* does other stuff, not touching err */

/* err == 0 here, because of above goto */
        return err;

out_ro:
        ubi_ro_mode(ubi);
        return err;


So, if this function should return zero when the erase block fails, then I
will add a "result" field to ubi_work that will store the result of the
work function. But I figured I'd check first if the return err that always
returns 0 is not an oversight and this function should return -EIO if it
fails.

cheers,
Joel Reardon

