Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0JYQnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:43:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39118 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0JYQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gc5kkdTzk1D2RVXZJM6a3GSh+tsvwckGIFu6yaEXRXlPoiUvl9Ii04xznlaccTN1+d
         YMSUI/jZUwWxGNP4l0fWSs9i8UbKD0TbCa8HF8a3pUe5qX9hgBAgQ2y2UdCOADJBENzQ
         9qZV89vhOykX7cVI0GKMDpFff/HuMsrq4g3h0=
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 18:43:12 +0200
Message-ID: <AANLkTikDEF=K05Pfi62+EcDRACU7horv7w54bRn_HwtQ@mail.gmail.com>
Subject: DMAENGINE: Client reuse of desc
From: Per Forlin <per.lkml@gmail.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

DMA_CTRL_ACK is used if the client needs to set up a dependency chain
of descriptor. This mean the driver cannot reuse or free the
descriptor until the client release it. I wonder if the client is
permitted/safe to reuse the descriptor and submit it again to the
driver? Or would dmaengine need an additional flag for this feature.

I know that the intent of DMA_CTRL_ACK is not to allow reuse of desc
from a client perspective. I am asking because I made this assumption
when implementing it in ste_dma40.

Example:
The client prepares a desc "A", submits "A" and starts the transfer.
When tx finished, the client then fills in new data in the desc
"A"-buffer and submits it again.

/Per
