Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0DSOgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:36:14 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44704
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0DSOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:36:13 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 10:36:13 EDT
X-IronPort-AV: E=Sophos;i="4.52,235,1270418400"; 
   d="scan'208";a="48711027"
Date: Mon, 19 Apr 2010 16:26:28 +0200
From: Samuel Thibault <samuel.thibault@labri.fr>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.0rc1 released
Message-ID: <20100419142628.GI5025@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the first
release candidate for v1.0:

   http://www.open-mpi.org/projects/hwloc/
   (mirrors will update shortly)

hwloc provides command line tools and a C API to obtain the
hierarchical map of key computing elements, such as: NUMA memory
nodes, shared caches, processor sockets, processor cores, and
processor "threads". hwloc also gathers various attributes such as
cache and memory information, and is portable across a variety of
different operating systems and platforms.

v1.0rc1 is the first milestone of a major feature release.  Many
features and changes have been added since the v0.9 series.  Although
v1.0rc1 is only a prerelease, we felt it important to announce the
first in the series in order to gain feedback and widespread testing
before v1.0 goes final.  Please try hwloc out on your system, read its
improved documentation, and send us your feedback.

The following is a summary of the changes since the v0.9 series (this
list may change before v1.0 goes final):

* The ABI of the library has changed.
* Backend updates
  + Add FreeBSD support.
  + Add x86 cpuid based backend.
  + Add Linux cgroup support to the Linux cpuset code.
  + Support binding of entire multithreaded process on Linux.
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

Samuel
