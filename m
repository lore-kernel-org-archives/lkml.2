Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2FNSb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:31:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23614 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2FNSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:31:25 -0400
Date: Thu, 14 Jun 2012 21:31:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: liplianin@me.by
Cc: linux-kernel@vger.kernel.org
Subject: re: [media] Altera FPGA firmware download module
Message-ID: <20120614183113.GB6383@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Igor M. Liplianin,

The patch fa766c9be58b: "[media] Altera FPGA firmware download 
module" from Jan 25, 2011, leads to the following warning:
drivers/misc/altera-stapl/altera.c:2204 altera_get_note()
	 error: strlcpy() 'key' too small (33 vs 256)

drivers/misc/altera-stapl/altera.c
  2200                  if ((i >= 0) && (i < note_count)) {
  2201                          status = 0;
  2202  
  2203                          if (key != NULL)
  2204                                  strlcpy(key, &p[note_strings +
  2205                                                  get_unaligned_be32(
  2206                                                  &p[note_table + (8 * i)])],
  2207                                          length);
  2208  
  2209                          if (value != NULL)
  2210                                  strlcpy(value, &p[note_strings +
  2211                                                  get_unaligned_be32(
  2212                                                  &p[note_table + (8 * i) + 4])],
  2213                                          length);
  2214  
  2215                          *offset = i + 1;

The problem is that strlcpy() is using 256 as the size of "key" but
actually it is the size of "value".  Except that "value" is 257 bytes so
it is an off by one of the size of "value".

It probably doesn't cause a problem, but it upsets the static checkers
and it's pretty ugly.

regards,
dan carpenter

