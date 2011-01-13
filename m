Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1AMHxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 02:53:48 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42129 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1AMHxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 02:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=W7UITuRBDqoJnmPQ++7FeOI8J3VNufwpwSXBWlrqtAkM8UrIvDhljXUykhEvJDwHPR
         qurjjAV4BMZv/spQs8jCPUL5h/xArzdY6DGPel6HOes56UO/p3aP98fsL5Il/Ib1qJOt
         AmbzLdKG+jyASA/47tYECdt8+k5wwGw7cQ0eg=
MIME-Version: 1.0
Date: Thu, 13 Jan 2011 00:53:44 -0700
Message-ID: <AANLkTi=zYzbz2cGXc-XWnF_vDk-4e4Qv+aUMROscrJHx@mail.gmail.com>
Subject: gcc NULL strings passed from ternary operators in kernel modules
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interesting case with gcc.  The following code example:

printk("%s\n", (value & 1) "set": "clear");

will evaluate to NULL unless the ":" character has a space after
static string declaration.

this version

printk("%s\n", (value & 1) "set" : "clear");

works.

go figure.   Looks like gcc assumes this case is a C++ construct of
some sort and
evaluates it to NULL.

Jeff
