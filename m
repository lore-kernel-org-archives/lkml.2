Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1AHDmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 22:42:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab1AHDmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:42:31 -0500
Date: Fri, 7 Jan 2011 22:42:22 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: kobject_put vs module unload
Message-ID: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm looking at some kobject problem in device mapper and I came across 
this problem:

According to kobject interface specification, If we embed a kobject into 
the device structure, we shouldn't free the device structure when the 
device is unloaded, but we should register a "release" callback in 
kobj_type that will actually free the device structure.

What happens in this scenario?:

1) someone references a device kobject
2) the device is unloaded (but the device structure is still in memory 
because of that reference)
3) the driver module is unloaded
4) the reference obtained at point 1) is dropped, kobject reference count 
reaches zero and the release callback is called. But that callback points 
to an unloaded module and causes a crash.

How is it solved? Am I missing something?

Mikulas
