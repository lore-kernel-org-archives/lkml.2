Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1FHFkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:40:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:47306 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1FHFkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:40:05 -0400
Date: Wed, 8 Jun 2011 07:40:02 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Latest merge of 'drm-radeon-fixes' breaks my setup
Message-ID: <20110608054002.GA1717@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
(RS780). The mouse cursor is just a black block suddenly and I see an
endless stream of:
 radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid format 26                                           
 [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !

A quick git-bisect points to:
commit fe6f0bd03d697835e76dd18d232ba476c65b8282
Author: Marek Olšák <maraeo@gmail.com>
Date:   Sat May 7 01:09:57 2011 +0200

    drm/radeon/kms: add missing Evergreen texture formats to the CS parser

Reverting the commit solves the issue.

-- 
Markus
