Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0ERQW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:22:57 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:63232
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab0ERQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:22:55 -0400
X-IronPort-AV: E=Sophos;i="4.53,256,1272837600"; 
   d="scan'208";a="50827581"
Date: Tue, 18 May 2010 18:22:53 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware Locality (hwloc) v1.0 released
Message-ID: <20100518162253.GH4960@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is tremendously pleased to announce the release of version 1.0:

   http://www.open-mpi.org/projects/hwloc/ 
   (mirrors will update shortly) 

hwloc provides command line tools and a C API to obtain the hierarchical map of key computing elements, such as: NUMA memory nodes, shared caches, processor sockets, processor cores, and processor "threads".  hwloc also gathers various attributes such as cache and memory information, and is portable across a variety of different operating systems and platforms. 

The hwloc team considers version 1.0 to be the first production-quality release that is suitable for widespread adoption.  Please send your feedback on hwloc experiences to our mailing lists (see the web site, above).

The following is a summary of the changes since the v0.9 series.

* The ABI of the library has changed since the v0.9 series.
* Backend updates
  + Add FreeBSD support.
  + Add x86 cpuid based backend.
  + Add Linux cgroup support to the Linux cpuset code.
  + Support binding of entire multithreaded process on Linux.
  + Fix and enable Group support in Windows.
  + Cleanup XML export/import.
* Objects
  + HWLOC_OBJ_PROC is renamed into HWLOC_OBJ_PU for "Processing Unit",
    its stringified type name is now "PU".
  + Use new HWLOC_OBJ_GROUP objects instead of MISC when grouping
    objects according to NUMA distances or arbitrary OS aggregation.
  + Rework memory attributes.
  + Add different cpusets in each object to specify processors that
    are offline, unavailable, ...
  + Cleanup the storage of object names and DMI infos.
* Features
  + Add support for looking up specific PID topology information.
  + Add hwloc_topology_export_xml() to export the topology in a XML file.
  + Add hwloc_topology_get_support() to retrieve the supported features
    for the current topology context.
  + Support non-SYSTEM object as the root of the tree, use MACHINE in
    most common cases.
  + Add hwloc_get_*cpubind() routines to retrieve the current binding
    of processes and threads.
* API
  + Add HWLOC_API_VERSION to help detect the currently used API version.
  + Add missing ending "e" to *compare* functions.
  + Add several routines to emulate PLPA functions.
  + Rename and rework the cpuset and/or/xor/not/clear operators to output
    their result in a dedicated argument instead of modifying one input.
  + Deprecate hwloc_obj_snprintf() in favor of hwloc_obj_type/attr_snprintf().
  + Clarify the use of parent and ancestor in the API, do not use father.
  + Replace hwloc_get_system_obj() with hwloc_get_root_obj().
  + Return -1 instead of HWLOC_OBJ_TYPE_MAX in the API since the latter
    isn't public.
  + Relax constraints in hwloc_obj_type_of_string().
  + Improve displaying of memory sizes.
  + Add 0x prefix to cpuset strings.
* Tools
  + lstopo now displays logical indexes by default, use --physical to
    revert back to OS/physical indexes.
  + Add colors in the lstopo graphical outputs to distinguish between online,
    offline, reserved, ... objects.
  + Extend lstopo to show cpusets, filter objects by type, ...
  + Renamed hwloc-mask into hwloc-calc which supports many new options.
* Documentation
  + Add a hwloc(7) manpage containing general information.
  + Add documentation about how to switch from PLPA to hwloc.
  + Cleanup the distributed documentation files.
* Miscellaneous
  + Many compilers warning fixes.
  + Cleanup the ABI by using the visibility attribute.
  + Add project embedding support.
